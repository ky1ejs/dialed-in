import { MutationResolvers } from "src/__generated__/graphql";
import { GraphQLError } from "graphql";
import coffeeMapper from "src/resolvers/mappers/coffeeMapper";
import { WeightUnit } from "@prisma/client";
const createCoffeeResolver: MutationResolvers["createCoffee"] = async (_, input, { prisma, user }) => {
  if (!user) {
    throw new GraphQLError("Unauthorized", {
      extensions: {
        code: "UNAUTHORIZED",
        http: {
          status: 401
        }
      }
    })
  }
  let existingCoffee = await prisma.coffee.findFirst({
    where: {
      name: input.coffee.name,
      roaster: {
        name: input.coffee.roasterName
      }
    }
  })
  const coffee = existingCoffee ?? await prisma.coffee.create({
    data: {
      name: input.coffee.name,
      roast: input.coffee.roast,
      notes: input.coffee.notes ?? undefined,
      roaster: {
        connectOrCreate: {
          where: {
            name: input.coffee.roasterName
          },
          create: {
            name: input.coffee.roasterName
          }
        }
      },
    }
  })

  const bag = await prisma.coffeeBag.create({
    data: {
      roastDate: input.coffee.roastDate ? new Date(input.coffee.roastDate) : null,
      user: {
        connect: {
          id: user.id
        }
      },
      coffee: {
        connect: {
          id: coffee.id
        }
      },
      weight: input.coffee.weight?.value ?? undefined,
      weightUnit: input.coffee.weight?.unit ?? WeightUnit.GRAMS
    },
    include: {
      coffee: {
        include: {
          roaster: true
        }
      }
    }
  })

  return coffeeMapper(bag)
}

export default createCoffeeResolver;