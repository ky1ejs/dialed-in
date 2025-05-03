
import { Prisma } from "@prisma/client";
import { QueryResolvers } from "../__generated__/graphql";

const coffeesResolver: QueryResolvers["coffees"] = async (_, { filter }, { prisma }) => {
  const where: Prisma.CoffeeWhereInput = {};
  if (filter?.roasterId) {
    where.roasterId = filter.roasterId;
  }
  if (filter?.roastDate) {
    where.roastDate = filter.roastDate;
  }
  const coffees = await prisma.coffee.findMany({
    where,
  });
  return coffees.map((coffee) => ({
    ...coffee,
    roastDate: coffee.roastDate.toISOString(),
  }));
}

export default coffeesResolver;
