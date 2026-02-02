const app = document.getElementById('app');
const modesContainer = document.getElementById('modes');
const confirmDialog = document.getElementById('confirm');
const keybindLabel = document.getElementById('keybind');
const advancedToggle = document.getElementById('toggle-advanced');
const previewToggle = document.getElementById('toggle-preview');

let pendingMode = null;
let currentMode = 'off';
let isVisible = false;
let advancedEnabled = false;
let previewEnabled = false;
let orderedModes = [];

const setVisible = (visible) => {
  isVisible = visible;
  if (visible) {
    app.classList.remove('hidden');
  } else {
    app.classList.add('hidden');
  }
};

const formatPercent = (value) => `${Math.round(value * 100)}%`;

const updateToggleState = (button, enabled) => {
  if (!button) {
    return;
  }
  button.classList.toggle('control--active', enabled);
};

const renderModes = (modes, current) => {
  currentMode = current;
  orderedModes = modes.map((mode) => mode.key);
  modesContainer.innerHTML = '';
  modes.forEach((mode) => {
    const card = document.createElement('div');
    card.className = 'mode';
    card.dataset.mode = mode.key;

    const header = document.createElement('div');
    header.className = 'mode__header';

    const title = document.createElement('div');
    title.className = 'mode__title';
    title.textContent = mode.label;

    if (mode.badge) {
      const badge = document.createElement('span');
      badge.className = 'mode__badge';
      badge.textContent = mode.badge;
      header.append(title, badge);
    } else {
      header.appendChild(title);
    }

    const desc = document.createElement('div');
    desc.className = 'mode__desc';
    desc.textContent = mode.description || 'Preset';

    const stats = document.createElement('div');
    stats.className = 'mode__stats';
    stats.innerHTML = `
      <div>Vehicles: ${formatPercent(mode.vehicleDensity)}</div>
      <div>Peds: ${formatPercent(mode.pedestrianDensity)}</div>
      <div>Parked: ${formatPercent(mode.parkedVehicleDensity)}</div>
      <div>Scenario: ${formatPercent(mode.scenarioPedDensity)}</div>
      <div class="mode__flag"><span class="mode__dot ${mode.disableShadows ? '' : 'mode__dot--off'}"></span>Shadows</div>
      <div class="mode__flag"><span class="mode__dot ${mode.disableLights ? '' : 'mode__dot--off'}"></span>Lights</div>
      <div class="mode__flag"><span class="mode__dot ${mode.reduceParticles ? '' : 'mode__dot--off'}"></span>Particles</div>
    `;

    const advanced = document.createElement('div');
    advanced.className = 'mode__advanced';
    if (advancedEnabled) {
      advanced.classList.add('mode__advanced--open');
    }
    advanced.innerHTML = `
      <div>Random Vehicles: ${formatPercent(mode.randomVehicleDensity)}</div>
      <div>Timecycle: ${mode.timecycle || 'Default'}</div>
    `;

    const actions = document.createElement('div');
    actions.className = 'mode__actions';

    const applyButton = document.createElement('button');
    applyButton.className = 'mode__action';
    applyButton.textContent = 'Apply';
    applyButton.addEventListener('click', () => handleModeSelect(mode.key, false));

    const previewButton = document.createElement('button');
    previewButton.className = 'mode__action mode__action--ghost';
    previewButton.textContent = 'Preview';
    previewButton.addEventListener('click', () => handleModeSelect(mode.key, true));

    actions.append(applyButton, previewButton);

    card.append(header, desc, stats, advanced, actions);
    if (mode.key === current) {
      card.classList.add('active');
    }

    modesContainer.appendChild(card);
  });
};

const postMode = (endpoint, mode) => {
  fetch(`https://${GetParentResourceName()}/${endpoint}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: JSON.stringify({ mode })
  });
};

const handleModeSelect = (mode, usePreview) => {
  if (mode === 'off' && currentMode !== 'off' && !usePreview) {
    pendingMode = mode;
    confirmDialog.classList.remove('hidden');
    return;
  }

  const endpoint = usePreview || previewEnabled ? 'previewMode' : 'setMode';
  postMode(endpoint, mode);
};

const closeConfirm = () => {
  confirmDialog.classList.add('hidden');
  pendingMode = null;
};

window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.type === 'toggle') {
    setVisible(data.visible);
    if (data.modes) {
      renderModes(data.modes, data.current);
    }
    if (data.keybind && keybindLabel) {
      keybindLabel.textContent = data.keybind;
    }
  }

  if (data.type === 'update') {
    currentMode = data.current;
    const active = modesContainer.querySelectorAll('.mode');
    active.forEach((card) => {
      card.classList.toggle('active', card.dataset.mode === data.current);
    });
  }
});

if (advancedToggle) {
  advancedToggle.addEventListener('click', () => {
    advancedEnabled = !advancedEnabled;
    updateToggleState(advancedToggle, advancedEnabled);
    const advancedSections = modesContainer.querySelectorAll('.mode__advanced');
    advancedSections.forEach((section) => {
      section.classList.toggle('mode__advanced--open', advancedEnabled);
    });
  });
}

if (previewToggle) {
  previewToggle.addEventListener('click', () => {
    previewEnabled = !previewEnabled;
    updateToggleState(previewToggle, previewEnabled);
  });
}

document.addEventListener('click', (event) => {
  const target = event.target;
  if (!(target instanceof HTMLElement)) {
    return;
  }

  if (target.dataset.action === 'close') {
    fetch(`https://${GetParentResourceName()}/close`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify({})
    });
  }

  if (target.dataset.action === 'confirm') {
    if (pendingMode) {
      postMode('setMode', pendingMode);
    }
    closeConfirm();
  }

  if (target.dataset.action === 'cancel') {
    closeConfirm();
  }
});

document.addEventListener('keydown', (event) => {
  if (!isVisible) {
    return;
  }

  if (event.key === 'Escape') {
    if (!confirmDialog.classList.contains('hidden')) {
      closeConfirm();
      return;
    }

    fetch(`https://${GetParentResourceName()}/close`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify({})
    });
    return;
  }

  if (!confirmDialog.classList.contains('hidden')) {
    return;
  }

  const number = Number.parseInt(event.key, 10);
  if (!Number.isNaN(number) && number > 0 && number <= orderedModes.length) {
    const modeKey = orderedModes[number - 1];
    handleModeSelect(modeKey, previewEnabled);
  }
});
