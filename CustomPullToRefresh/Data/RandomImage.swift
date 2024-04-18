//
//  RandomImage.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 07/03/24.
//

import Foundation

struct RandomImage: Identifiable {
    
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    
    static func samples() -> [RandomImage] {
        [
            RandomImage(name: "Alexander Kovalev",
                        imageName: "pexels-alexander-kovalev-1631778",
                        description: "Perched atop a cliffside, an ancient oak tree spreads its branches like arms reaching for the sky, its gnarled roots clinging fiercely to the rocky soil as if holding onto the secrets of the ages."),
            RandomImage(name: "Brett Sayles",
                        imageName: "pexels-brett-sayles-4734933",
                        description: "Within a tranquil garden, cherry blossoms rain down like confetti in springtime, painting the earth with delicate petals while the scent of jasmine fills the air, intoxicating all who wander through."),
            RandomImage(name: "Cottonbro Studio",
                        imageName: "pexels-cottonbro-studio-4937197",
                        description: "Beneath a star-studded sky, a meandering stream reflects the celestial dance above, its waters shimmering with the light of a thousand galaxies as fireflies twinkle like distant stars on the banks."),
            RandomImage(name: "Egor Kamelev",
                        imageName: "pexels-egor-kamelev-927497",
                        description: "In the heart of the forest, sunlight filters through a canopy of emerald leaves, painting the ground with dappled shadows and illuminating the dance of butterflies."),
            RandomImage(name: "Iliescu Victor",
                        imageName: "pexels-iliescu-victor-306198",
                        description: "At dawn, the mountains stand sentinel, cloaked in mist like ancient guardians watching over the valleys below, where rivers carve through the landscape like veins of life."),
            RandomImage(name: "Jeswin Thomas",
                        imageName: "pexels-jeswin-thomas-713148",
                        description: "Fields of golden wheat sway in the breeze, rippling like waves upon an ocean of earth, while the distant call of a lone bird echoes across the horizon."),
            RandomImage(name: "Magda Ehlers",
                        imageName: "pexels-magda-ehlers-1054713",
                        description: "Beneath the azure sky, a meadow blooms with a kaleidoscope of wildflowers, each petal a brushstroke in nature's masterpiece, inviting bees to dance in their fragrant embrace."),
            RandomImage(name: "Magda Ehlers",
                        imageName: "pexels-magda-ehlers-1337387",
                        description: "In the tranquil serenity of a lakeside retreat, the water mirrors the sky above, creating a seamless reflection of clouds drifting lazily by and the vibrant hues of sunset."),
            RandomImage(name: "Max Rahubovskiy",
                        imageName: "pexels-max-rahubovskiy-6782567",
                        description: "Amidst a forest clearing, a waterfall cascades down rugged cliffs, its rhythmic symphony mingling with the chorus of birdsong and the rustle of leaves in the gentle breeze."),
            RandomImage(name: "Photo Miguel. Padriñán",
                        imageName: "pexels-photo-Miguel Á. Padriñán",
                        description: "Along the rugged coastline, cliffs rise defiantly against the crashing waves, carved by centuries of relentless tides into intricate formations that tell tales of resilience and time."),
            RandomImage(name: "Picjumbo.com",
                        imageName: "pexels-picjumbocom-196645",
                        description: "In a hidden glen, moss blankets ancient stones, softening their edges with a verdant embrace, while shafts of sunlight pierce through the canopy above, casting ethereal rays upon the forest floor."),
            RandomImage(name: "Pixabay 51932",
                        imageName: "pexels-pixabay-51932",
                        description: "Across the desert sands, the sun sets ablaze the horizon in a fiery display of oranges and pinks, while the silhouettes of cacti stand stark against the vast expanse of sky."),
            RandomImage(name: "Pixabay 158651",
                        imageName: "pexels-pixabay-158651",
                        description: "Nestled in a valley, a patchwork quilt of farmland stretches to the horizon, where rolling hills meet the sky in a seamless embrace, painted with the hues of each passing season."),
            RandomImage(name: "Pixabay 247781",
                        imageName: "pexels-pixabay-247781",
                        description: "Beneath the canopy of a jungle, the air hums with life as exotic creatures flit between lush foliage, their vibrant plumage a symphony of color against a backdrop of emerald green."),
            RandomImage(name: "Pixabay 260024",
                        imageName: "pexels-pixabay-260024",
                        description: "Along a tranquil riverbank, willows bow gracefully, their tendrils trailing in the water's embrace, while dragonflies dart and skim across the surface like fleeting jewels."),
            RandomImage(name: "Pixabay 269318",
                        imageName: "pexels-pixabay-269318",
                        description: "High in the alpine meadows, wildflowers cling tenaciously to rocky slopes, their delicate blooms a testament to nature's resilience in the face of harsh mountain winds."),
            RandomImage(name: "Tirachard Kumtanom",
                        imageName: "pexels-tirachard-kumtanom-733856",
                        description: "Beneath the surface of the ocean, a vibrant coral reef teems with life, its kaleidoscope of colors rivaling the splendor of any earthly paradise, as fish dart and dance among the labyrinthine structures."),
            RandomImage(name: "Valery 4103247",
                        imageName: "pexels-valery-4103247",
                        description: "In the heart of the savannah, the grasslands stretch endlessly to the horizon, punctuated by the silhouettes of acacia trees, where lions bask in the golden light of dawn, masters of their domain.")
        ]
    }
    
    static func example1() -> RandomImage {
        RandomImage(name: "Pixabay 51932",
                    imageName: "pexels-pixabay-51932",
                    description: "Across the desert sands, the sun sets ablaze the horizon in a fiery display of oranges and pinks, while the silhouettes of cacti stand stark against the vast expanse of sky.")
    }
    
    static func example2() -> RandomImage {
        RandomImage(name: "Picjumbo.com",
                    imageName: "pexels-picjumbocom-196645",
                    description: "In a hidden glen, moss blankets ancient stones, softening their edges with a verdant embrace, while shafts of sunlight pierce through the canopy above, casting ethereal rays upon the forest floor.")
    }
}









