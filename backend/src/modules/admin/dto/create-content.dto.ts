import { IsIn, IsString, MaxLength, MinLength } from 'class-validator';

export class CreateContentDto {
  @IsIn(['subject', 'chapter', 'lesson', 'flashcard', 'quiz_question'])
  type!: string;

  @IsString()
  @MinLength(2)
  @MaxLength(160)
  title!: string;

  @IsString()
  @MaxLength(8000)
  body!: string;
}
