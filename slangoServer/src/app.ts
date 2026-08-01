import express from 'express';
import cors from 'cors';
import mundoRoutes from './routes/mundoRoutes';
import usuarioRoutes from './routes/usuarioRoutes';

const app = express();

app.use(cors());
app.use(express.json());
app.use('/api', usuarioRoutes);
app.use('/api', mundoRoutes);

export default app;