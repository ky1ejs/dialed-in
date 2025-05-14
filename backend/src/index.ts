import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { resolvers } from './resolvers/resolvers';
import prisma from './prisma';
import { UserContext } from './context';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

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
    context: async ({ req }) => {
      const token = req.headers.authorization;
      let user: UserContext | null = null;
      if (token) {
        try {
          const device = await prisma.device.findUnique({ where: { sessionId: token }, include: { user: true } })
          if (device) {
            user = { ...device.user, device: device }
          }
        } catch {
        }
      }
      return { prisma, user };
    }
  }));

  app.listen(port, () => {
    console.log(`🚀 Server ready at http://localhost:${port}/graphql`);
  });
}

startServer().catch((err) => {
  console.error('Error starting server:', err);
}); 