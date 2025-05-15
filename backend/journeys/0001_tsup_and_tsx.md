# tsup and tsx

## Need
I want to use path aliases in my TypeScript code. Unfortuantely, this doesn't work with with vanilla tsc + node, as tsc doesn't now how to handle the imports.

## Solution
### tsup
Cursor & ChatGPT offered using a few options: tsup, esbuild and webpack. tsup was the easiest to set up and didn't require me to define the path aliases in other files in addition to the tsconfig.json file. 

#### Side effects
1. In order for tsup to work with the imports, we needed to change the module resolution in `tsconfig.json` to one of `es2022`, `esnext` etc.
2. `__dirname` and `__filename` are not available in the compiled code when using ES Modules, so you need to use the `import.meta.url` and `import.meta.dirname` properties.

### Swapping ts-node for tsx
`ts-node` does not support the `import.meta.url` and `import.meta.dirname` properties, so we need to swap it out for `tsx` [which does](https://github.com/privatenumber/ts-runtime-comparison?tab=readme-ov-file#transformation).






## What is Tsup?

tsup is a build tool for TypeScript. It is a drop-in replacement for TSC.

## Why Tsup?

Purely for support for relative imports. I couldn't get this to work with vanilla tsc + node. Upon asking Cursor to resolve this, it set up tsup. 

I'm not sure I'll keep it because I've not looked into it much at all, but for now it makes using relative imports easier, which in turn are easier to work with.

