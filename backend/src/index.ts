import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { readFileSync } from 'fs';
import { join } from 'path';
import { resolvers } from './resolvers';
import { context } from './context';

dotenv.config();

const app = express();
const port = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

const typeDefs = readFileSync(join(__dirname, '../dialed-in.graphqls'), 'utf-8');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: process.env.NODE_ENV !== 'production',
});

async function startServer() {
  await server.start();

  app.use('/graphql', expressMiddleware(server, {
    context: async () => context
  }));

  app.listen(port, () => {
    console.log(`🚀 Server ready at http://localhost:${port}/graphql`);
  });
}

startServer().catch((err) => {
  console.error('Error starting server:', err);
}); 