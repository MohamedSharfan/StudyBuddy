import { IsString } from 'class-validator';

export class SubmitAnswerDto {
  @IsString()
  questionId!: string;

  @IsString()
  optionId!: string;
}
