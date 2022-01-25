/*
Return an array containing only the mammals
*/

const animals = document.querySelectorAll('.all-animals .animal');
const mammals = document.getElementById('only-mammals');

animals.forEach((animal) => {
  if (animal.children[1].textContent === 'mammal: true') {
    console.log(animal);
    mammals.appendChild(animal.cloneNode(true));
  }
});
