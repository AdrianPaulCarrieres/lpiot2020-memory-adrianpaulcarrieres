import { ApiCardModel } from "./api-card.model";

export interface ApiDeckModel {
    card_back: String,
        theme: String,
        cards: [ApiCardModel]
}