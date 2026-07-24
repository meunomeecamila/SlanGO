import express from 'express';
import cors from 'cors';
import mundoRoutes from './routes/mundoRoutes.ts';

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando na porta ${PORT}`);
});