import cloudinary from '../utils/cloudnary';
import { UploadApiResponse, UploadApiErrorResponse } from 'cloudinary';

export const uploadImage = async (filePath: string): Promise<string> => {
  try {
    const result: UploadApiResponse = await cloudinary.uploader.upload(filePath, {
      folder: 'meu_app_uploads',
      use_filename: true,
      unique_filename: false,
    });

    return result.secure_url;
    
  } catch (error) {
    const err = error as UploadApiErrorResponse;
    throw new Error('Falha no upload da imagem');
  }
};