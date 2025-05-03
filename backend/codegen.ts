import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: 'dialed-in.graphqls',
  generates: {
    'src/__generated__/graphql.ts': {
      plugins: ['typescript', 'typescript-resolvers'],
      config: {
        contextType: '../context#Context',
      },
    },
  },
};

export default config; 