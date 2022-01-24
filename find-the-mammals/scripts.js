/*
Return an array containing only the mammals
*/

animals = [
  {
    type: 'Dog',
    mammal: true,
  },
  {
    type: 'Snake',
    mammal: false,
  },
  {
    type: 'Cheetah',
    mammal: true,
  },
];

const mammals = [];
animals.forEach((animal) => {
  if (animal.mammal) mammals.push(animal);
});

console.log(mammals);
