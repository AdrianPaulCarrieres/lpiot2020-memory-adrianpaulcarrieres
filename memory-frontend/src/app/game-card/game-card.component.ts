import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Card, Deck } from '../models';


@Component({
  selector: 'app-game-card',
  templateUrl: './game-card.component.html',
  styleUrls: ['./game-card.component.css']
})
export class GameCardComponent implements OnInit {

  @Input() card: Card;
  @Input() deck: Deck;

  @Output() cardClicked = new EventEmitter();

  constructor() { }

  ngOnInit(): void {
  }

}
