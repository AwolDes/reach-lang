'reach 0.1';

export const DELAY = 10; // in blocks

export const Player =
  { getHand: Fun([], Bytes),
    partnerIs: Fun([Address], Null) };
export const Alice =
  { ...Player,
    getParams: Fun([], Array(UInt256, UInt256)),
    commits: Fun([], Null),
    reveals: Fun([Bytes], Null) };
export const Bob =
  { ...Player,
    acceptParams: Fun([UInt256, UInt256], Null),
    shows: Fun([], Null) };

export const [ isHand, ROCK, PAPER, SCISSORS ] = makeEnum(3);
export function showHand(handX) {
  require(isHand(handX));
  if ( handX == ROCK ) { return 'ROCK'; }
  else if ( handX == PAPER ) { return 'PAPER'; }
  else { return 'SCISSORS'; } };

function _getHand(interact) {
  const s = interact.getHand();
  const rockP = s === 'ROCK';
  const paperP = s === 'PAPER';
  const scissorsP = s === 'SCISSORS';
  assume(rockP || paperP || scissorsP);
  if (rockP) { return ROCK; }
  else if (paperP) { return PAPER; }
  else { return SCISSORS; } };
export function getHand(interact) {
  return ensure(isHand, _getHand(interact)); };

export const [ isOutcome, B_WINS, DRAW, A_WINS, A_QUITS, B_QUITS ] = makeEnum(5);
export function showOutcome(o) {
  require(isOutcome(o));
  if (o == B_WINS) { return 'Bob wins'; }
  else if (o == DRAW) { return 'Draw'; }
  else if (o == A_WINS) { return 'Alice wins'; }
  else if (o == A_QUITS) { return 'Alice quits'; }
  else { return 'Bob quits'; } };

function _winner(handA, handB) {
  const validA = isHand(handA);
  const validB = isHand(handB);
  if (validA && validB) {
    return (handA + (4 - handB)) % 3; }
  else if (validA) {
    return A_WINS; }
  else if (validB) {
    return B_WINS; }
  else {
    return DRAW; } };
export function winner(handA, handB) {
  return ensure(isOutcome, _winner(handA, handB)); };

function fair_if(handX, optionX, canWinX) {
  return possible((handX == optionX) && canWinX); };

function fair_for_player(handX, canWinX) {
  fair_if(handX, ROCK, canWinX);
  fair_if(handX, PAPER, canWinX);
  fair_if(handX, SCISSORS, canWinX); };

export function fair_game(handA, handB, outcome) {
  fair_for_player(handA, (outcome == A_WINS));
  fair_for_player(handB, (outcome == B_WINS)); };
