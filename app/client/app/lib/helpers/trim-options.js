export default function trimOptions(options) {
  const newOptions = { ...options };

  for (const option of Object.keys(newOptions)) {
    if (newOptions[option] === '' || newOptions[option] === undefined) delete newOptions[option];
  }

  return newOptions;
}
