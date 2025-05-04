
import { QueryResolvers } from "../../__generated__/graphql";
import coffeeMapper from "src/resolvers/mappers/coffeeMapper";

const coffeeBagsResolver: QueryResolvers["coffeeBags"] = async (_, __, { prisma, user }) => {
  if (!user) {
    throw new Error("User not found");
  }
  const coffeeBags = await prisma.coffeeBag.findMany({
    where: {
      userId: user.id
    },
    orderBy: {
      roastDate: "desc"
    },
    include: {
      coffee: {
        include: {
          roaster: true
        }
      }
    }
  });
  return coffeeBags.map(coffeeMapper);
}

export default coffeeBagsResolver;
