import { IsString, MaxLength, MinLength } from 'class-validator';

export class UploadKnowledgeDto {
  @IsString()
  @MinLength(2)
  @MaxLength(180)
  title!: string;

  @IsString()
  @MinLength(20)
  content!: string;
}
