import { Resolvers } from '../__generated__/graphql';
import { Context } from '../context';
import initiateAuthResolver from './auth/initiateAuthResolver';
import isUsernameAvailableResolver from './auth/isUsernameAvailableResolve';
import validateAuthResolver from '@/resolvers/auth/validateAuthResolver';
import completeAccountResolver from 'src/resolvers/auth/CompleteAccountResolver';
import createCoffeeResolver from 'src/resolvers/mutations/createCoffeeResolver';
import coffeeBagsResolver from 'src/resolvers/queries/coffeeBagsResolver';
import prisma from 'src/prisma';
export const resolvers: Resolvers<Context> = {
  Query: {
    coffeeBags: coffeeBagsResolver,
    lastUsedCoffee: () => {
      return {
        id: '1',
        name: 'Honey',
        roasterName: 'Devocion'
      };
    },
    isUsernameAvailable: isUsernameAvailableResolver,
    _healthCheck: async () => {
      const result = await prisma.$executeRaw`SELECT 1`;
      return result > 0;
    },
  },
  Mutation: {
    initiateAuth: initiateAuthResolver,
    validateAuth: validateAuthResolver,
    completeAccount: completeAccountResolver,
    createCoffee: createCoffeeResolver,
  },
}; 