import { Body, Controller, Get, Param, Post } from '@nestjs/common';

import { AdminService } from './admin.service';
import { CreateContentDto } from './dto/create-content.dto';
import { UploadKnowledgeDto } from './dto/upload-knowledge.dto';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('dashboard')
  dashboard() {
    return this.adminService.dashboard();
  }

  @Get('content')
  content() {
    return this.adminService.content();
  }

  @Get('workflow')
  workflow() {
    return this.adminService.workflow();
  }

  @Post('content')
  createContent(@Body() dto: CreateContentDto) {
    return this.adminService.createContent(dto);
  }

  @Post('knowledge-documents')
  uploadKnowledge(@Body() dto: UploadKnowledgeDto) {
    return this.adminService.uploadKnowledge(dto);
  }

  @Post('knowledge-documents/:id/embed')
  embedKnowledge(@Param('id') documentId: string) {
    return this.adminService.embedKnowledge(documentId);
  }
}
