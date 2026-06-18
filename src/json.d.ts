// The grammar and language-configuration JSON live outside src/ (they double as
// standalone editor assets shipped in the package), so they are intentionally
// not part of the TS program's rootDir. Declare them ambiently: dts emit types
// them as opaque data blobs, while esbuild/tsup inlines the actual JSON into the
// runtime bundle at build time. This avoids the "file is not under rootDir"
// error that resolveJsonModule triggers for out-of-tree imports.
declare module '*.json' {
  const value: Record<string, any>;
  export default value;
}
