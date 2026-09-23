import test from 'node:test';
import assert from 'node:assert/strict';
import { greeting } from '../src/index.js';

test('prepared workspace example', () => {
  assert.equal(greeting(), 'hello from prepared workspace');
});
