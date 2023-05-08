const board = instance.signature('Board').atoms()[0];
const cells = instance.signature('Cell').atoms();
const wallconstraints = instance.signature('WallConstraint').atoms();
const innerconstraints = instance.signature('InteriorConstraint').atoms();

// what renders the board on the screen

const stage = new Stage();


const n = board.join(instance.field('size'));
const offset = 60
const cell_off = 50
const cell_size = 50

const top_bot_x_offset = offset + 25
const top_y_offset = 30
const left_x_offset = 30
const bot_y_offset = n * cell_size + offset + 25
const left_right_y_offset = offset + 25
const right_x_offset = n * cell_size + offset + 25

for (let i = 0; i < wallconstraints.length; i++) {
    const wall = wallconstraints[i].join(instance.field('wall'))
    const index = wallconstraints[i].join(instance.field('index'))
    const hint = wallconstraints[i].join(instance.field('hint'))
    if (wall == 'Top0') {
        stage.add(new TextBox(hint, { x: top_bot_x_offset + index * cell_size, y: 30 }, 'black', 30))
    }
    if (wall == 'Bot0') {
        stage.add(new TextBox(hint, { x: top_bot_x_offset + index * cell_size, y: bot_y_offset }, 'black', 30))
    }
    if (wall == 'Rgt0') {
        stage.add(new TextBox(hint, { x: right_x_offset, y: left_right_y_offset + index * cell_size }, 'black', 30))
    }
    if (wall == 'Lft0') {
        stage.add(new TextBox(hint, { x: left_x_offset, y: left_right_y_offset + index * cell_size }, 'black', 30))
    }
}

for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
        stage.add(new Rectangle(cell_size, cell_size, { x: offset + cell_size * i, y: offset + cell_size * j }, 'gray'))
    }
}

for (let i = 0; i < innerconstraints.length; i++) {
    const wall = innerconstraints[i].join(instance.field('wall'))
    const r = innerconstraints[i].join(instance.field('const_row'))
    const c = innerconstraints[i].join(instance.field('const_col'))
    const hint = innerconstraints[i].join(instance.field('hint'))
    //  x: offset + 25 + cell_col * cell_off, y: offset + 25 + cell_row * cell_off }
    if (wall == 'Top0') {
        stage.add(new TextBox(hint + "v", { x: offset + 12 + c * cell_off, y: offset + r * cell_off }, 'black', 15))
    }
    if (wall == 'Bot0') {
        stage.add(new TextBox(hint + "^", { x: offset + 33 + c * cell_off, y: offset + r * cell_off + cell_off }, 'black', 15))
    }
    if (wall == 'Rgt0') {
        stage.add(new TextBox("<" + hint, { x: offset + c * cell_off + cell_off, y: offset + 14 + r * cell_off }, 'black', 15))
    }
    if (wall == 'Lft0') {
        stage.add(new TextBox(hint + ">", { x: offset + c * cell_off, y: offset + 33 + r * cell_off }, 'black', 15))
    }
}


for (let i = 0; i < cells.length; i++) {
    const cell_row = cells[i].join(instance.field('cell_row'))
    const cell_col = cells[i].join(instance.field('cell_col'))
    const cell_val = cells[i].join(instance.field('val'))
    stage.add(new TextBox(cell_val, { x: offset + 25 + cell_col * cell_off, y: offset + 25 + cell_row * cell_off }, 'white', 30))
}

stage.render(svg, document)