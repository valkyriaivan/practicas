import web3 from "./web3";
import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  "0x99e3B4097463C366C7330EDb463E40Ba8Ca5E583"
);

export default instance;
