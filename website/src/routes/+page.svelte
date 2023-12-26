<script lang="ts">
	let history = '$ ';
	let command = 'help';
	let display = '';

	$: if (!display.startsWith(history)) display = history + command;

	const commands = {
		''() {
			return '';
		},
		about() {
			return 'about';
		},
		links() {
			return 'links';
		},
		résumé() {
			setTimeout(open, 1000, 'resume');
			return 'opening résumé…';
		},
		help() {
			return 'help';
		},
		clear() {
			history = '$ ';
			return '';
		}
	};

	function execCommand() {
		command = command.trim().replace(/\s+/g, ' ');
		const cmd = command as keyof typeof commands;
		const out = (commands[cmd] ?? commands.help)();
		history += `${command}\n${out}\n\n$ `;
		display = history;
		command = '';
	}

	execCommand();
</script>

<nav>
	{#each Object.keys(commands) as cmd}
		<button
			on:click={() => {
				command = cmd;
				execCommand();
			}}
		>
			{cmd}
		</button>
	{/each}
</nav>

<textarea
	bind:value={display}
	on:keyup={({ key, ctrlKey, shiftKey }) => {
		if (key == 'Enter' && !shiftKey) execCommand();
		else if (key == 'c' && ctrlKey) display = history;
		else command = display.slice(history.length);
	}}
	spellcheck="false"
/>

<style>
	:global(body) {
		height: 100vh;
		background: black;
		margin: 0;
		display: flex;
		flex-direction: column;
	}

	button {
		font-size: medium;
		margin: 1rem;
		padding: 0;
		background: none;
		color: #deafff;
		border: none;
		cursor: pointer;
	}

	textarea {
		flex-grow: 1;
		padding: 1rem;
		background: none;
		color: white;
		border: none;
		outline: none;
		resize: none;
	}
</style>
