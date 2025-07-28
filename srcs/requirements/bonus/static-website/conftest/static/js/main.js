const CaseType = {
    bomb: -2,
    found: -1,
};

/*

    Define Main Variables

*/

let MAP;
let started = false;
let bombs = () => {
    return 10;
};
let gridSize = () => {
    return {
        x: 10,// document.getElementById("grid-entry").value,
        y: 10,// document.getElementById("grid-entry").value
    };
};
let needToClick = ((gridSize().x * gridSize().y) - bombs()) - 1;
let firstCoords = {};


let findedCases = [];
let flaggedCases = [];
let bombCoords = [];
let renderBomb = () => {
    return false; // document.getElementById("render-bomb").checked;
};;

/*

    Classes

*/

class Coordinates {
    constructor(x, y) {

        this._x = parseInt(x);
        this._y = parseInt(y);

    }

    get x() {
        return this._x;
    }

    get y() {
        return this._y;
    }

    set x(value) {
        this._x = parseInt(value);
    }

    set y(value) {
        this._y = parseInt(value);
    }

    // function to get good format to "object"
    getString() {
        return `${this._x}-${this._y}`;
    }

    isValid(gridSize) {
        if (this._x < 0 || this._x > gridSize.x - 1 || this._y < 0 || this._y > gridSize.y - 1)
            return false;
        return true;
    }

}

class Map {
    constructor(width, height, bombs, renderBomb = false) {

        // basics properties
        this._width = width;
        this._height = height;
        this._bombs = bombs;
        this._gridSize = new Coordinates(
            this._width,
            this._height
        );

        // UI properties
        this._renderBomb = renderBomb;

        // create a map with x and y array
        this._map = {};

        // saves all importants location
        this._flaggedCell = [];
        this._bombsCell = [];
        this._foundCell = [];

        // generate the map (cell & column & row)
        this.generateGrid();

    }
    /* 

        Getter and Setter
    
    */
    get map() {
        return this._map;
    }

    get width() {
        return this._width;
    }

    get height() {
        return this._height;
    }

    set width(value) {
        this._width = value;
    }

    set height(value) {
        this._height = value;
    }

    /* 

        Getter Methods
    
    */

    get(location) {
        return this._map[`${location.x}-${location.y}`] || 0;
    }

    getCaseTexture(location) {
        return this.get(location) || 0;
    }

    getCoordsFromString(str) {
        return new Coordinates(str.split('-')[0], str.split('-')[1]);
    }

    /* 

        Setter Methods
    
    */

    setValue(location, value = 0) {
        this._map[location.getString()] = value;
    }

    setFlag(location, set = false) {
        if (!set)
            this._flaggedCell.push(location.getString());
        else {
            this._flaggedCell = this._flaggedCell.filter((flag) => flag !== location.getString());
            this.setCellTexture(location, 'case');
        }
    }

    setFound(location) {
        this._foundCell.push(location.getString());
    }

    setCellTexture(location, texture) {
        if (document.getElementById(`${location.x}-${location.y}`))
            document.getElementById(`${location.x}-${location.y}`).src = `assets/${texture}.png`;
    }

    /* 

        Checker 
    
    */

    isFlag(location) {
        if (this._flaggedCell.includes(location.getString()))
            return true;
        return false;
    }

    isFound(location) {
        if (this._foundCell.includes(location.getString()))
            return true;
        return false;
    }

    isBomb(location) {
        if (this.get(location) === CaseType['bomb'])
            return true;
        return false;
    }

    isNumber(location) {
        if (this.get(location) > 0)
            return true;
        return false;
    }

    isZero(location) {
        if (this.get(location) === 0 || !this.get(location))
            return true;
        return false;
    }

    /* 

        Render Methods
    
    */

    revealCase(location, stop = false) {

        if (this.isBomb(location)) return; // check if is bomb
        if (this.isFound(location)) return; // check if is already found
        if (this.isFlag(location)) return; // check if is flag

        needToClick--; // update variable score needToClick
        updateScore(); // update score label

        this.setCellTexture(location, `case_${this.get(location)}`); // set cell texture to the cell value
        this.setFound(location); // set cell as found

        if (this.isNumber(location)) return; // if it's number don't find around
        // Reveal adjacent empty cases recursively
        for (let x = -1; x <= 1; x++) { // set x loop
            for (let y = -1; y <= 1; y++) { // set y loop
                if (x === 0 && y === 0) continue; // don't take the main cell 
                let loc = new Coordinates(location.x + x, location.y + y);
                if (loc.x < 0 || loc.x > this._gridSize.x - 1 || loc.y < 0 || loc.y > this._gridSize.y - 1) continue; // check boundaries
                this.revealCase(loc); // reveal location
            }
        }
    }

    revealFlag() {
        // get all flag locations
        this._flaggedCell.forEach((flag) => {
            // tranform str location to new Coordinates
            let location = this.getCoordsFromString(flag);
            // get if is good flag -> if not case not bomb
            if (!this.isBomb(location))
                this.setCellTexture(location, 'case_not_bomb'); // set the cell texture
        });
    }

    revealBombs() {
        // get all bombs
        this._bombsCell.forEach((bomb) => {
            // if the bomb is flagged -> no reveal
            if (!this.isFlag(bomb))
                this.setCellTexture(bomb, 'case_bomb'); // set the cell texture
        });
    }

    /* 

        Generate Methods
    
    */

    generateBombs(expetLocation) {

        // generate all bombs locations
        this._bombsCell = this.randomLocations(expetLocation, this._bombs);

        // set the texture and the cell value
        for (let i = 0; i <= this._bombsCell.length - 1; i++) {
            let location = this._bombsCell[i];
            this.setValue(location, CaseType['bomb']); // set the random locations to bomb
            if (renderBomb()) // if render bomb is checked, then show bomb
                this.setCellTexture(location, `case_bomb`);
        }

        // calcule all numbers around
        this._bombsCell.forEach((bomb) => {
            for (let x = -1; x <= 1; x++) { // set x loop
                for (let y = -1; y <= 1; y++) { // set y loop
                    if (x === 0 && y === 0) continue; // don't get the bomb location
                    const loc = new Coordinates(bomb.x + x, bomb.y + y); // get location for the number
                    if (!loc.isValid(new Coordinates(this._width, this._height))) continue; // check if location is valid
                    if (this.isBomb(loc)) continue; // continue if it's bomb 
                    if (this.isFound(loc)) continue; // continue if it's already found

                    this.setValue(loc, this.get(loc) + 1); // update the number (around the bomb)
                }
            }
        });
    }

    generateGrid() {
        // Sélectionnez l'élément parent pour ajouter la grille
        var parent = document.getElementById("main-grid");

        // Créez une boucle pour générer la grille avec les éléments HTML
        for (var i = 0; i < this._height; i++) {
            // Créez un élément de colonne
            var column = document.createElement("div");
            column.id = "column-" + i;
            column.className = "column";

            // Ajoutez une colonne à l'élément parent
            parent.appendChild(column);

            for (var j = 0; j < this._width; j++) {
                // Créez un élément de case
                var cell = document.createElement("a");
                cell.setAttribute('onclick', `leftClick(${j}, ${i})`);
                cell.setAttribute('oncontextmenu', `rightClick(${j}, ${i})`);
                // Ajoutez une case à la colonne
                column.appendChild(cell);

                // Créez un élément d'image pour la case
                var image = document.createElement("img");
                image.id = `${j}-${i}`;
                image.src = "assets/case.png";

                // Ajoutez l'image à la case
                cell.appendChild(image);
            }
        }
    };

    /* 

        Random Methods
    
    */

    randomLocations(expetLocation, n) {
        let allTestedLocations = [];
        let locations = [];
        const isForbidden = location => location.x >= expetLocation.x - 1 && location.x <= expetLocation.x + 1 && location.y >= expetLocation.y - 1 && location.y <= expetLocation.y + 1;

        while (locations.length < n) {
            let location = new Coordinates(
                getRandomInt(this._gridSize.x) - 1,
                getRandomInt(this._gridSize.y) - 1
            );
            if (isForbidden(location) === false && !allTestedLocations.includes(location.getString()) && location.isValid(new Coordinates(this._width, this._height))) {
                locations.push(location);
                allTestedLocations.push(location.getString());
            }
        }

        return locations;
    }


}

/*

    Game Main Functions

*/


function initGame(location) {
    started = true;
    MAP.generateBombs(location);
}

function endGame(location) {
    // reveal all flag
    MAP.revealFlag();
    // reveal all bombs
    MAP.revealBombs();

    // set the current cell to red bomb
    MAP.setCellTexture(location, 'case_red_bomb');
}

function win() {
    alert('You win !');
}



/*

    Actions (player)

*/

function leftClick(x, y) {

    // define left cliked coords
    const location = new Coordinates(x, y);

    // Check if the game is already started
    if (!started) {
        // if yes init the playground/map
        initGame(location);
    }

    // check if is flag 
    if (MAP.isFlag(location)) return;

    // check if is bomb 
    if (MAP.isBomb(location)) {
        return endGame(location);
    }

    if (needToClick == 0 && !MAP.isFound(location)) {
        win();
    }
    // return if is defined 
    else if (MAP.isFound(location)) return;
    MAP.revealCase(location);
}

function rightClick(x, y) {
    // define left cliked coords
    const location = new Coordinates(x, y);

    // check if the case is already clicked 
    if (MAP.isFlag(location)) {
        return MAP.setFlag(location, true); // set flag in map
    }
    if (MAP.isFound(location)) return; // don't do anything if is already found

    // save as a flag
    MAP.setFlag(location);
    // apply the flag texture 
    MAP.setCellTexture(location, `case_flag`);
}


/*

    Random Functions 

*/

function getRandomInt(max) {
    return Math.floor(Math.random() * max) + 1;
}

function start() {
    // create a map
    MAP = new Map(gridSize().x, gridSize().y, bombs());
    // console.log(MAP.isBomb(new Coordinates(0, 0)));
    // disable start btn
    document.getElementById('start-btn').setAttribute("disabled", "true");

    // update the current score to the selected area
    updateScore();
}

/*

    Others Functions

*/

function updateScore() {
    document.getElementById(`score`).innerHTML = `Score : ${((gridSize().x * gridSize().y) - bombs()) - needToClick}/${(gridSize().x * gridSize().y) - bombs()}`;
}

// prevent context menu appearing
document.addEventListener("contextmenu", (e) => {
    e.preventDefault();
});