#!/usr/bin/env bash
set -euo pipefail

API_URL="https://api.clore.ai"
API_KEY=""
MARKET_FILE="market.json"
SERVER_ID=""
MAX_PRICE=""
ORDER_TYPE="on-demand"
IMAGE="cloreai/jupyter:ubuntu24.04-v1"
SSH_PASSWORD="CloreBashRent123!"
CURRENCY="CLORE-Blockchain"

usage() {
  cat <<EOF
Usage: $0 [options]

Fetch the Clore marketplace, search a stored market file, or rent a server within a max price.

Options:
  --api-key KEY       Clore API key (or set CLORE_API_KEY)
  --market-file PATH  Output file path (default: market.json)
  --server-id ID      Search local market file for the specified server ID, or rent that server when used with --max-price
  --max-price PRICE   Rent the cheapest available server with price <= PRICE, or rent the given server if --server-id is also provided
  -h, --help          Show this help message
EOF
  exit 1
}

fetch_marketplace() {
  local response
  response=$(curl -sS -H "auth: $API_KEY" -H "Content-Type: application/json" \
    "$API_URL/v1/marketplace")

  if [[ $? -ne 0 || -z "$response" ]]; then
    error "Failed to fetch marketplace from $API_URL/v1/marketplace"
  fi

  printf '%s' "$response" > "$MARKET_FILE"
  printf '%s' "$response"
}

find_server_in_market() {
  if [[ ! -f "${MARKET_FILE}" ]]; then
    error "Local market file not found: $MARKET_FILE"
  fi

  local result
  result=$(jq -c --arg server_id "$SERVER_ID" \
    '[.servers[] | select(
       (( $server_id == "" ) or (.id == ($server_id | tonumber)))
     )] | if length == 1 then .[0] else . end' "$MARKET_FILE")

  if [[ -z "$result" || "$result" == "null" || "$result" == "[]" ]]; then
    error "No servers found matching server-id='$SERVER_ID' in $MARKET_FILE"
  fi

  printf '%s\n' "$result"
}

create_order() {
  local server_id="$1"
  local payload
  payload=$(cat <<EOF
{
  "renting_server": $server_id,
  "type": "$ORDER_TYPE",
  "currency": "$CURRENCY",
  "image": "$IMAGE",
  "ports": {"22": "tcp"},
  "env": {"NVIDIA_VISIBLE_DEVICES": "all"},
  "ssh_password": "$SSH_PASSWORD"
}
EOF
)

  local response
  response=$(curl -sS -X POST -H "auth: $API_KEY" -H "Content-Type: application/json" \
    -d "$payload" "$API_URL/v1/create_order")

  if [[ $? -ne 0 || -z "$response" ]]; then
    error "Failed to create rent order for server $server_id"
  fi

  printf '%s\n' "$response"
}

rent_server_by_price() {
  if [[ -z "$MAX_PRICE" ]]; then
    error "--max-price is required to rent by price"
  fi

  if [[ ! "$MAX_PRICE" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    error "Invalid max price: $MAX_PRICE"
  fi

  local response
  response=$(fetch_marketplace)

  local server
  if [[ -n "$SERVER_ID" ]]; then
    server=$(printf '%s' "$response" | jq -c --argjson sid "$SERVER_ID" '.servers[] | select(.id == $sid)')
    if [[ -z "$server" || "$server" == "null" ]]; then
      error "Server ID $SERVER_ID not found in marketplace"
    fi
    local server_price
    server_price=$(printf '%s' "$server" | jq -r '.price.usd.on_demand_clore // empty')
    if [[ -z "$server_price" ]]; then
      error "Server ID $SERVER_ID does not publish on-demand pricing"
    fi
    if [[ $(awk 'BEGIN{print ('$server_price' > '$MAX_PRICE') ? 1 : 0}') -eq 1 ]]; then
      error "Server price $server_price exceeds max price $MAX_PRICE"
    fi
  else
    server=$(printf '%s' "$response" | jq -c --argjson max "$MAX_PRICE" '
      .servers
      | map(select(.rented == false and ((.price.usd.on_demand_clore // 1e9) <= $max)))
      | sort_by(.price.usd.on_demand_clore)
      | .[0]')
    if [[ -z "$server" || "$server" == "null" ]]; then
      error "No available server found with price <= $MAX_PRICE"
    fi
  fi

  local server_id
  server_id=$(printf '%s' "$server" | jq -r '.id')
  printf 'Selected server %s for rent: %s\n' "$server_id" "$server"
  create_order "$server_id"
}

error() {
  echo "ERROR: $1" >&2
  exit 1
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --api-key)
        API_KEY="$2"; shift 2;;
      --market-file)
        MARKET_FILE="$2"; shift 2;;
      --server-id)
        SERVER_ID="$2"; shift 2;;
      --max-price)
        MAX_PRICE="$2"; shift 2;;
      -h|--help)
        usage;;
      *)
        echo "Unknown option: $1" >&2
        usage;;
    esac
  done
}

parse_args "$@"

if [[ -n "${MAX_PRICE}" ]]; then
  if [[ -z "${API_KEY:-}" ]]; then
    if [[ -n "${CLORE_API_KEY:-}" ]]; then
      API_KEY="$CLORE_API_KEY"
    else
      error "API key is required to rent a server. Use --api-key or set CLORE_API_KEY."
    fi
  fi
  rent_server_by_price
  exit 0
fi

if [[ -n "${SERVER_ID}" ]]; then
  find_server_in_market
  exit 0
fi

if [[ -z "${API_KEY:-}" ]]; then
  if [[ -n "${CLORE_API_KEY:-}" ]]; then
    API_KEY="$CLORE_API_KEY"
  else
    error "API key is required. Use --api-key or set CLORE_API_KEY."
  fi
fi

curl -sS -H "auth: $API_KEY" -H "Content-Type: application/json" \
  "$API_URL/v1/marketplace" \
  -o "$MARKET_FILE"

if [[ $? -ne 0 ]]; then
  error "Failed to fetch marketplace from $API_URL/v1/marketplace"
fi

echo "Marketplace saved to $MARKET_FILE"
