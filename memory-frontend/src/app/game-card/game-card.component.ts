import { trigger, state, style, transition, animate } from '@angular/animations';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Card, Deck } from '../models';



@Component({
  selector: 'app-game-card',
  templateUrl: './game-card.component.html',
  styleUrls: ['./game-card.component.css'],
  animations: [
    trigger('cardFlip', [
      state('false', style({
        transform: 'none',
      })),
      state('true', style({
        transform: 'perspective(600px) rotateY(180deg)'
      })),
      transition('false => true', [
        animate('400ms')
      ]),
      transition('true => false', [
        animate('400ms')
      ])
    ])
  ]
})
export class GameCardComponent implements OnInit {

  @Input() card: Card;
  @Input() deck: Deck;

  @Output() cardClicked = new EventEmitter();

  constructor() { }

  ngOnInit(): void {
  }
}
