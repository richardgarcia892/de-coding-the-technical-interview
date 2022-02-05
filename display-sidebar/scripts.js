'use strict';
/*
Return an array containing only the mammals
*/
const sideItems = document.querySelectorAll('.wrapper .sidebar ul li a');
const hamburger = document.querySelector('.hamburguer');

console.log(sideItems);

function deactiveAllItems() {
  sideItems.forEach((item) => item.classList.remove('active'));
}

function activeItem() {
  if (!this.classList.contains('active')) {
    deactiveAllItems();
    this.classList.add('active');
  }
}

function addSideItemsListener() {
  sideItems.forEach((item) => {
    item.addEventListener('click', activeItem);
  });
}

addSideItemsListener();

hamburger.addEventListener('click', function () {
  document.querySelector('body').classList.toggle('hidden');
});
