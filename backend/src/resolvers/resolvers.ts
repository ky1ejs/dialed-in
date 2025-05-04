import { Resolvers } from '../__generated__/graphql';
import { Context } from '../context';
import coffeesResolver from './coffeesResolver';
import initiateAuthResolver from './auth/initiateAuthResolver';
import isUsernameAvailableResolver from './auth/isUsernameAvailableResolve';
import validateAuthResolver from 'src/resolvers/auth/validateAuthResolver';
import completeAccountResolver from 'src/resolvers/auth/CompleteAccountResolver';

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
    isUsernameAvailable: isUsernameAvailableResolver,
  },
  Mutation: {
    initiateAuth: initiateAuthResolver,
    validateAuth: validateAuthResolver,
    completeAccount: completeAccountResolver,
  },
}; 