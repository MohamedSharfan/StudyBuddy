import { IsInt, IsOptional, IsString, Min } from 'class-validator';

export class CreateStudySessionDto {
  @IsString()
  activityType!: string;

  @IsOptional()
  @IsString()
  subjectId?: string;

  @IsInt()
  @Min(0)
  durationSeconds!: number;
}
