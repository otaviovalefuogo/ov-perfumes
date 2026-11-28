import express, {Request,Response,NextFunction} from 'express';
import cookieParser from 'cookie-parser';
import dotenv from 'dotenv';
import path from 'path';
import { pool } from './db';

dotenv.config();
const app= express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(cookieParser());
app.use(express.static(path.join(__dirname,'../public')));

app.get('/api/health', async (_req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.status(200).json({
      status: 'ok',
      database_time: result.rows[0].now,
    });
  } catch (error) {
    next(error);
  }
});
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error(err);
  res.status(500).json({ error: 'Erro interno do servidor' });
});
app.listen(PORT, () => {
  console.log(`Servidor Ov.perfumes rodando em http://localhost:${PORT}`);
});