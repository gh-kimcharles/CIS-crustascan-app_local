import '../models/crustacean_model.dart';

final List<Crustacean> crustaceanList = [
  // Blue Swimming Crab (Portunus pelagicus)
  Crustacean(
    id: "blue_swimming_crab",
    name: 'Blue Swimming Crab',
    type: 'Crab',
    scientificName: 'Portunus pelagicus',
    familyName: 'Portunidae',
    population: 'Heavily fished',
    description:
        'Blue Swimming Crab (Portunus pelagicus) is a large crab that can grow up to 20 cm wide. Males are bright blue with white spots and long claws, while females are green or brown with a rounder shell. The shell has a rough texture, four sharp teeth in the front, and nine teeth on each side, with the last tooth being the biggest. They spend much of their time buried in sand or mud, especially during the day and winter, which contributes to their high tolerance of ammonium (NH₄⁺) and ammonia (NH₃). They emerge primarily during high tide to feed on bivalves, fish, and occasionally macroalgae. They are excellent swimmers, thanks to a pair of paddle-shaped flattened legs. However, unlike their relative the mud crab (Scylla serrata), they cannot survive long outside water. The male’s chelae are elongated, with the larger claw featuring a conical tooth at the base of the fingers and a ridged pollex.',
    shortDescription:
        'Blue Swimming Crab (Portunus pelagicus) can grow up to 20 cm wide. Males are bright blue with long claws, while females are green or brown with a rounder shell. They spend most of their time buried in sand or mud and come out during high tide to feed on bivalves, fish, and occasionally macroalgae. They swim well with paddle-shaped legs but cannot survive long out of water.',
    imagePath: 'assets/images/species_desc/blue_swimming_crab_desc.jpg',
    sampleImagePath:
        'assets/images/species_desc/sample_images/blue_swimming_crab.png',
    imageDescription: "Blue Swimming Crab (Portunus pelagicus)",
  ),

  //  Mud Crab (Scylla serrata)
  Crustacean(
    id: "mud_crab",
    name: 'Mud Crab',
    type: 'Crab',
    scientificName: 'Scylla serrata',
    familyName: 'Portunidae',
    population: 'Common',
    description:
        'Mud crab (Scylla serrata), also known as the giant mud crab or mangrove crab, is a large swimming crab characterized by its oval carapace and massive claws. It is widely distributed across the Indian Ocean and the tropical Western Pacific, ranging from South Africa and the Red Sea to southern Japan, New Zealand, and Tahiti. This species thrives in estuaries, mangrove swamps, and brackish waters, where it plays an important ecological role as both predator and prey. It is recognized by its four triangular frontal teeth between the eyes and nine lateral teeth along each side of the carapace. Its chelipeds (claws) are powerful, smooth, and longer than the other legs, with distinct spines on the claw, wrist, and forearm. The legs are strong and slightly flattened, with the fourth pair adapted for swimming. Males have a narrow abdomen with fused segments, while females have a broadly oval abdomen. Their colors varies widely, ranging from green and purple to brown or black. Adults can grow impressively large, with carapace widths reaching up to 186 mm.',
    shortDescription:
        'Mud crab (Scylla serrata), also called the giant mud crab or mangrove crab, is a large swimming crab with an oval shell and strong claws. It lives in estuaries, mangroves, and brackish waters across the Indian Ocean and Western Pacific, from South Africa to Japan and Tahiti. The crab is recognized by its spiny shell, big claws, and swimming legs. Males have a narrow abdomen, while females have a broad one. Colors range from green and purple to brown or black, and adults can reach up to 18 cm wide.',
    imagePath: 'assets/images/species_desc/mud_crab_desc.jpg',
    sampleImagePath: 'assets/images/species_desc/sample_images/mud_crab.png',
    imageDescription: "Mud crab (Scylla serrata)",
  ),

  // River Crab (Potamonautes perlatus)
  Crustacean(
    id: "river_crab",
    name: 'River Crab',
    type: 'Crab',
    scientificName: 'Potamonautes perlatus',
    familyName: 'Potamonautidae',
    population: 'Abundant',
    description:
        'River Crab (Potamonautes perlatus) is a freshwater crab species primarily found in South Africa, particularly in the Cape Province, although its range extends to some unverified areas of Namibia. It preferentially inhabits rivers but is also abundant in farm dams, where its habit of burrowing tunnels is sometimes problematic. While this behavior is not a threat to well-built dams, it can pose problems to small farming structures. Since the species is river-adapted, it tends to leave isolated dams during rainy nights, but this behavior does not appear to diminish population stability. Well-established dam populations can persist indefinitely.',
    shortDescription:
        'River Crab (Potamonautes perlatus) is commonly found in South Africa\'s Cape Province and possibly Namibia, inhabits rivers and farm dams. While sometimes considered a pest for burrowing in earth dams, it plays an important ecological role as both predator and prey, as well as a detritus shredder and host for parasites.',
    imagePath: 'assets/images/species_desc/river_crab_desc.jpg',
    sampleImagePath: 'assets/images/species_desc/sample_images/river_crab.png',
    imageDescription: "River Crab (Potamonautes perlatus)",
  ),

  // Giant Tiger Prawn (Penaeus monodon)
  Crustacean(
    id: "tiger_prawn",
    name: 'Tiger Prawn',
    type: 'Prawn',
    scientificName: 'Penaeus monodon',
    familyName: 'Penaeidae',
    population: 'Farmed',
    description:
        'Giant Tiger Prawn (Penaeus monodon) is one of the largest species of prawns, with females reaching up to 33 cm (13 in) in length and typically ranging from 25 to 30 cm (10 to 12 in), weighing between 200 to 320 g (7 to 11.5 oz). Males are smaller, growing to 20 to 25 cm (8 to 10 in) and weighing 100 to 170 g (3.5 to 6 oz). The carapace and abdomen are banded with alternating red and white, while the pleopods range from brown to blue with reddish fringing setae. The antennae are grayish brown, and the body is smooth with a well-developed antennal and hepatic spine. The rostrum bears 7 to 8 dorsal teeth and 3 ventral teeth, with a horizontal, straight hepatic carina. Naturally distributed across the Indo-Pacific, giant tiger prawns inhabit regions from the eastern coast of Africa and the Arabian Peninsula to Southeast Asia, the Pacific islands, and northern Australia. In the wild, they are nocturnal, burrowing into the substrate by day and emerging at night to feed. Their diet consists of detritus, polychaete worms, mollusks, small crustaceans, and algae. While unable to consume living phytoplankton due to their feeding appendages, they can ingest senescent phytoplankton.',
    shortDescription:
        'Giant Tiger Prawn (Penaeus monodon) is among the largest prawn species, with females reaching up to 33 cm, while males are smaller at 20-25 cm. Its body is smooth, banded red and white, with grayish-brown antennae, blue to brown pleopods, and a rostrum armed with 7 to 8 dorsal and 3 ventral teeth. Native to the Indo-Pacific, it ranges from the eastern coast of Africa to Southeast Asia, the Pacific, and northern Australia. It is nocturnal by nature and burrows during the day and feeds at night on detritus, worms, mollusks, small crustaceans, algae, and senescent phytoplankton.',
    imagePath: 'assets/images/species_desc/tiger_prawn_desc.jpg',
    sampleImagePath: 'assets/images/species_desc/sample_images/tiger_prawn.jpg',
    imageDescription: "Giant Tiger Prawn (Penaeus monodon)",
  ),

  // Whiteleg Shrimp (Penaeus monodon)
  Crustacean(
    id: "whiteleg_shrimp",
    name: 'Whiteleg Shrimp',
    type: 'Shrimp',
    scientificName: 'Penaeus vannamei',
    familyName: 'Penaeidae',
    population: 'Farmed',
    description:
        'Whiteleg shrimp (Penaeus vannamei) is a shrimp species native to the eastern Pacific from Sonora, Mexico to northern Peru. The species can reach a length of 23 cm with a carapace length of 9 cm. Moderately long shrimps have a rostrum which is 7-10 dorsal and 2-4 ventral teeth long. Cetacean, the body is usually translucent white. However, the environmental and dietary conditions can differ. Adults prefer muddy bottoms in marine environments down to a depth of 72 meters, whereas juveniles are found in estuaries, coastal lagoons, and mangrove ecosystems. With the shallow coastal habitats\' tops and a better shrimp growth under 40‰ salinity and 15-33°C, makes it the most farmed species of shrimp in the world. In addition to these unique traits, they are also highly fecund, producing 100,000 to 250,000 eggs per spawn.',
    shortDescription:
        'Whiteleg shrimp (Penaeus vannamei) grows up to 23 cm, with a translucent white body and a rostrum bearing 7-10 dorsal and 2-4 ventral teeth. Native from Mexico to Peru, it inhabits marine bottoms and estuaries, tolerates broad salinity and temperature ranges, and is the world\'s most widely farmed shrimp species.',
    imagePath: 'assets/images/species_desc/whiteleg_shrimp_desc.jpg',
    sampleImagePath:
        'assets/images/species_desc/sample_images/whiteleg_shrimp.jpg',
    imageDescription: "Whiteleg shrimp (Penaeus vannamei)",
  ),
];
