import express from 'express';
import cors from 'cors';
import mundoRoutes from './routes/mundoRoutes';
import usuarioRoutes from './routes/usuarioRoutes';
import recuperarRoutes from './routes/recuperarRoutes';
import authRoutes from './routes/authRoutes';
import perfilRoutes from './routes/perfilRoutes';
import sugestaoRoutes from './routes/sugestaoRoutes';
import rankRoutes from './routes/rankRoutes';

const app = express();

app.use(cors());
app.use(express.json());
app.use('/api', usuarioRoutes);
app.use('/api', mundoRoutes);
app.use('/api', recuperarRoutes);
app.use('/api', authRoutes);
app.use('/api', perfilRoutes);
app.use('/api/ranking', rankRoutes);
app.use('/api', sugestaoRoutes);

export default app;