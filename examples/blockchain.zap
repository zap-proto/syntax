# ZAP Protocol - Blockchain Schema
# Warp messaging and consensus types for Lux Network

@0xc4a18f7e9b2d5c31;

# Warp message for cross-chain communication
struct WarpMessage @0 {
  sourceChainId @0 :Data;      # 32 bytes
  destinationChainId @1 :Data;  # 32 bytes
  payload @2 :Data;
  timestamp @3 :Int64;
  nonce @4 :UInt64;

  # Signatures from validators
  signatures @5 :List(ValidatorSignature);
}

struct ValidatorSignature @1 {
  validatorId @0 :Data;  # 20 bytes (address)
  signature @1 :Data;    # 65 bytes (ECDSA)
  weight @2 :UInt64;
}

# Consensus vote structure
struct ConsensusVote @2 {
  blockHash @0 :Data;     # 32 bytes
  height @1 :UInt64;
  round @2 :UInt32;
  voteType @3 :VoteType;
  validatorIndex @4 :UInt32;
  signature @5 :Data;
  timestamp @6 :Int64;
}

enum VoteType @3 {
  prevote @0;
  precommit @1;
  commit @2;
}

# Batch of votes (zero-copy friendly)
struct VoteBatch @4 @packed {
  votes @0 :List(ConsensusVote);
  aggregatedSignature @1 :Data;  # BLS aggregate
  bitmap @2 :Data;               # Validator participation
}

# Validator set for epoch
struct ValidatorSet @5 {
  epoch @0 :UInt64;
  validators @1 :List(Validator);
  totalWeight @2 :UInt64;
  threshold @3 :UInt64;  # 2/3 of total weight
}

struct Validator @6 {
  address @0 :Data;      # 20 bytes
  publicKey @1 :Data;    # 48 bytes (BLS)
  weight @2 :UInt64;
  active @3 :Bool = true;
}

# State access pattern (mmap-friendly)
struct StateAccess @7 @aligned(64) {
  key @0 :Data;
  value @1 :Data;
  proof @2 :List(Data);
  version @3 :UInt64;
}

# Block header (zero-copy)
struct BlockHeader @8 @packed {
  parentHash @0 :Data;   # 32 bytes
  stateRoot @1 :Data;    # 32 bytes
  txRoot @2 :Data;       # 32 bytes
  receiptsRoot @3 :Data; # 32 bytes
  height @4 :UInt64;
  timestamp @5 :Int64;
  proposer @6 :Data;     # 20 bytes
  signature @7 :Data;    # 65 bytes
}

# Transaction (arena allocated)
struct Transaction @9 {
  from @0 :Data;         # 20 bytes
  to @1 :Data;           # 20 bytes
  value @2 :Data;        # 32 bytes (uint256)
  data @3 :Data;
  nonce @4 :UInt64;
  gasLimit @5 :UInt64;
  gasPrice @6 :Data;     # 32 bytes
  signature @7 :Data;    # 65 bytes
  chainId @8 :UInt64;
}

# Tool call for AI agents (minimal overhead)
struct ToolCall @10 {
  id @0 :UInt64;
  name @1 :Text;
  arguments @2 :Data;  # MessagePack or JSON
  timeout @3 :UInt32 = 30000;  # ms
}

struct ToolResult @11 {
  callId @0 :UInt64;
  success @1 :Bool;
  result @2 :Data;
  error @3 :Text;
  durationMs @4 :UInt32;
}

# MCP server routing
service MCPRouter @12 {
  rpc Route (ToolCall) returns (ToolResult);
  rpc BatchRoute (stream ToolCall) returns (stream ToolResult);
  rpc ListTools () returns (ToolList);
}

struct ToolList @13 {
  tools @0 :List(ToolInfo);
}

struct ToolInfo @14 {
  name @0 :Text;
  description @1 :Text;
  inputSchema @2 :Text;  # JSON Schema
  server @3 :Text;       # MCP server name
}
