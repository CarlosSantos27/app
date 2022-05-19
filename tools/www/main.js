const listComponents = document.querySelector(".list-components");
const infoSection = document.querySelector(".preview-component");

const titleComponent = document.querySelector(".title-component");
const imageContent = document.querySelector(".content-image");
let itemIndex = 0;

window.addEventListener("load", function () {
	photosdatabase.forEach((value) => {
		createItem(value);
	});
});

function createItem(item) {
	const itemComponent = document.createElement("div");
	itemComponent.innerHTML = `<h3>${item.name}</h3>`;
	itemComponent.classList.add("item-component");
	listComponents.appendChild(itemComponent);
	itemComponent.onclick = function () {
        infoSection.querySelector(".content-image").classList.remove('multiple');
        showComponent(item);
		document.querySelector(".item-selected")?.classList.remove("item-selected");
		itemComponent.classList.add("item-selected");
	};
	if (itemIndex == 0) {
        itemComponent.click();
		itemIndex++;
	}
}

function showComponent(item) {
    fillInfo(item);
	console.log(typeof item.imagePreview);
	if (typeof item.imagePreview === "string") {
        renderSingleImage(item);
	} else if (typeof item.imagePreview === "object") {
        rednerMultipleImage(item);
	}
}

function renderSingleImage(item) {
	const contentImg = infoSection.querySelector(
		".content-image"
	).innerHTML = `<img src="./img/preview/${item.imagePreview}">`;
}

function rednerMultipleImage(item) {
    const contentImg = infoSection.querySelector(".content-image");
    contentImg.classList.add('multiple');
    contentImg.innerHTML='';
	item.imagePreview.forEach((img) => {
		const imgElement = document.createElement("img");
        imgElement.src = `./img/preview/${img}`;
		contentImg.appendChild(imgElement);
	});
}

function fillInfo(item) {
	infoSection.querySelector(
		".title-component"
	).innerHTML = `<h2>${item.name}</h2>`;
	infoSection.querySelector(".info-desc").innerHTML = `<h3>${item.desc}</h3>`;
}
