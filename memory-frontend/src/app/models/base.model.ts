export class BaseModel {

  public id: string;

  constructor(private data?: any) {
    if (data.id) {
      this.id = data.id;
      delete this.data;
    }
  }
}