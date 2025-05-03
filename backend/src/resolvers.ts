import { Resolvers } from './__generated__/graphql';
import { Context } from './context';
import coffeesResolver from './resolvers/coffeesResolver';

export const resolvers: Resolvers<Context> = {
  Query: {
    coffees: coffeesResolver,
    lastUsedCoffee: () => {
      return {
        id: '1',
        name: 'Honey',
        roaster: 'Devocion'
      };
    },
  },
  Mutation: {
  },
}; 