import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { ApiCardModel } from './api-models/api-card.model';
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

  get_cards_image(deck_id: String){
    return this.http.get<ApiDeckModel>(this.api + "/decks/" + deck_id);
  }

  get_card_image(deck_id: String, card_id: String){
    return this.http.get<ApiCardModel>(this.api + "/decks/" + deck_id + "/cards/" + card_id);
  }
}
