import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { ApiDeckModel } from './api-models/api-deck.model';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  
  api = environment.api_endpoint;

  constructor(private http: HttpClient) { }

  get_deck_image(id: String){
    return this.http.get<ApiDeckModel>(this.api + "/decks/" + id);
  }

  
}
