export function greeting() {
  return 'hello from prepared workspace';
}

if (process.argv[1]?.endsWith('index.js')) console.log(greeting());
