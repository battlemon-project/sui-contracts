// module contracts::model {
//     use sui::object::UID;
//     use sui::url::Url;
//     use contracts::trait::Trait;
//
//     struct Model<Kind, TraitName, TraitFlavour> has key {
//         id: UID,
//         kind: Kind,
//         url: Url,
//         traits: vector<Trait<TraitName, TraitFlavour>>,
//     }
// }
//