import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Deck } from '../models';

@Component({
  selector: 'app-deck',
  templateUrl: './deck.component.html',
  styleUrls: ['./deck.component.css']
})
export class DeckComponent implements OnInit {

  @Input() deck: Deck;
  @Output() deckClicked = new EventEmitter();

  constructor() { }

  ngOnInit(): void {
  }

}
