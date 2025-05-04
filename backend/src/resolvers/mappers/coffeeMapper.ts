import { Coffee, CoffeeBag, Roaster } from "@prisma/client";
import { Coffee as GraphQLCoffee } from "src/__generated__/graphql";

type CoffeeWithRoaster = CoffeeBag & { coffee: Coffee & { roaster: Roaster } }

export default function coffeeMapper(bag: CoffeeWithRoaster): GraphQLCoffee {
  return {
    id: bag.id,
    name: bag.coffee.name,
    roasterName: bag.coffee.roaster.name,
    roastDate: bag.roastDate ? bag.roastDate.toISOString() : null,
    weight: bag.weight,
    weightUnit: bag.weightUnit as GraphQLCoffee['weightUnit'],
  }
}