# ZAP Protocol Schema Example
# Zero-copy Application Protocol for the age of AI & crypto

@0xdbb9ad1f14bf0b36;  # Unique file ID

using Go = import "/go.zap";
using Rust = import "/rust.zap";

# Basic struct with field IDs
struct Point @0 {
  x @0 :Float64;
  y @1 :Float64;
  z @2 :Float64 = 0.0;  # Default value
}

# Nested struct with list
struct Shape @1 {
  name @0 :Text;
  vertices @1 :List(Point);
  color @2 :Color = red;
}

# Enum definition
enum Color @2 {
  red @0;
  green @1;
  blue @2;
  custom @3;
}

# Union type (tagged union)
struct Value @3 {
  union {
    void @0 :Void;
    bool @1 :Bool;
    int @2 :Int64;
    float @3 :Float64;
    text @4 :Text;
    data @5 :Data;
    list @6 :List(Value);
  }
}

# RPC interface
interface Calculator @4 {
  add @0 (a :Float64, b :Float64) -> (result :Float64);
  multiply @1 (a :Float64, b :Float64) -> (result :Float64);

  # Streaming RPC
  streamSum @2 (values :stream Float64) -> (total :Float64);
}

# Service definition (for routing)
service MathService @5 {
  rpc Calculate (CalculateRequest) returns (CalculateResponse);
  rpc BatchCalculate (stream CalculateRequest) returns (stream CalculateResponse);
}

struct CalculateRequest @6 {
  operation @0 :Text;
  operands @1 :List(Float64);
}

struct CalculateResponse @7 {
  result @0 :Float64;
  error @1 :Text;
}

# Annotations for code generation
annotation doc @8 (target :*) :Text;
annotation deprecated @9 (target :*) :Void;
annotation packed @10 (target :struct) :Void;
annotation aligned @11 (target :field) :UInt32;

# Annotated struct
struct Message @12 @doc("High-performance message type") {
  id @0 :UInt64 @aligned(8);
  timestamp @1 :Int64;
  payload @2 :Data;
  metadata @3 :Map(Text, Text);
}

# Generic type (parameterized)
struct Result(T, E) @13 {
  union {
    ok @0 :T;
    err @1 :E;
  }
}

# Constants
const maxMessageSize :UInt32 = 16777216;  # 16 MB
const version :Text = "1.0.0";
const magicNumber :UInt64 = 0x5A415000;  # "ZAP\0"

# Using groups for organization
struct NetworkPacket @14 {
  header :group {
    version @0 :UInt8;
    flags @1 :UInt8;
    length @2 :UInt16;
    checksum @3 :UInt32;
  }

  payload @4 :Data;

  trailer :group {
    padding @5 :Data;
    signature @6 :Data;
  }
}
