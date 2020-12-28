import { trigger, state, style, transition, animate } from '@angular/animations';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Card, Deck } from '../models';



@Component({
  selector: 'app-game-card',
  templateUrl: './game-card.component.html',
  styleUrls: ['./game-card.component.css'],
  animations: [
    trigger('cardFlip', [
      state('0', style({
        transform: 'none',
      })),
      state('1', style({
        transform: 'perspective(600px) rotateY(180deg)'
      })),
      transition('0 => 1', [
        animate('400ms')
      ]),
      transition('1 => 0', [
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
