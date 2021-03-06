import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { GameCardComponent } from './game-card/game-card.component';
import { GameComponent } from './game/game.component';
import { HomeComponent } from './home/home.component';
import { LobbyComponent } from './lobby/lobby.component';
import { DeckComponent } from './deck/deck.component';
import { ChannelService } from './services/channel.service';


@NgModule({
  declarations: [
    AppComponent,
    LobbyComponent,
    HomeComponent,
    GameComponent,
    GameCardComponent,
    DeckComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    BrowserAnimationsModule,
    HttpClientModule,
  ],
  providers: [ChannelService],
  bootstrap: [AppComponent]
})
export class AppModule { }
