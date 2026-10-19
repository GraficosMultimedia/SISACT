(function (root) {
  'use strict';
  const money = n => Math.round((n + Number.EPSILON) * 100) / 100;
  const number = v => v === '' || v === null || v === undefined ? null : Number(v);
  function calculate(job, machine) {
    const errors = [];
    const read = (key, label, { required = false, min = 0, max = 1e9, integer = false } = {}) => {
      const n = number(job[key]);
      if (n === null) {
        if (required) errors.push({ field: key, message: label + ': captura un valor.' });
        return 0;
      }
      if (!Number.isFinite(n) || n < min || n > max || (integer && !Number.isInteger(n))) {
        errors.push({ field: key, message: label + ': revisa el valor' + (integer ? ' entero' : '') + '.' });
        return 0;
      }
      return n;
    };
    const quantity = read('quantity', 'Cantidad', { required: true, min: 1, max: 1000000, integer: true });
    const width = read('width', 'Ancho de pieza', { required: true, min: 0.01, max: 10000 });
    const height = read('height', 'Alto de pieza', { required: true, min: 0.01, max: 10000 });
    read('thickness', 'Espesor', { max: 1000 });
    if (job.material === 'Otro' && !String(job.customMaterial || '').trim()) errors.push({ field: 'customMaterial', message: 'Captura el nombre del material.' });
    const bedW = Number(machine.width), bedH = Number(machine.height);
    if (!Number.isFinite(bedW) || !Number.isFinite(bedH) || bedW <= 0 || bedH <= 0) {
      errors.push({ field: 'machine', message: 'Configura las medidas válidas del área de trabajo.' });
    } else if (width && height && !((width <= bedW && height <= bedH) || (height <= bedW && width <= bedH))) {
      errors.push({ field: 'width', message: 'La pieza no cabe en el área de trabajo de ' + bedW + ' × ' + bedH + ' cm, incluso girada.' });
    }
    if (!['shop', 'customer'].includes(job.supply)) errors.push({ field: 'supply', message: 'Selecciona quién proporciona el material.' });
    let materialCost = 0, area = width * height * quantity, sheets = 0, perSheet = 0, chargeArea = area;
    const waste = job.supply === 'shop' ? read('waste', 'Merma', { max: 100 }) : 0;
    if (job.supply === 'shop') {
      const sheetW = read('sheetWidth', 'Ancho de hoja', { required: true, min: 0.01, max: 100000 });
      const sheetH = read('sheetHeight', 'Largo de hoja', { required: true, min: 0.01, max: 100000 });
      const sheetPrice = read('sheetPrice', 'Costo de hoja', { required: true, min: 0.01 });
      if (!['area', 'sheets'].includes(job.chargeMode)) errors.push({ field: 'chargeMode', message: 'Selecciona cómo se cobra el material.' });
      if (sheetW && sheetH && width && height) {
        perSheet = Math.max(Math.floor((sheetW + 1e-8) / width) * Math.floor((sheetH + 1e-8) / height), Math.floor((sheetW + 1e-8) / height) * Math.floor((sheetH + 1e-8) / width));
        if (perSheet === 0) errors.push({ field: 'sheetWidth', message: 'La pieza no cabe en la hoja de material, incluso girada.' });
        chargeArea = area * (1 + waste / 100);
        sheets = perSheet > 0 ? Math.ceil((quantity * (1 + waste / 100) - 1e-10) / perSheet) : 0;
        materialCost = job.chargeMode === 'sheets' ? sheets * sheetPrice : chargeArea / (sheetW * sheetH) * sheetPrice;
      }
    }
    const cut = read('cutMinutes', 'Minutos de corte', { max: 1000000 });
    const engrave = read('engraveMinutes', 'Minutos de grabado', { max: 1000000 });
    if (cut + engrave <= 0) errors.push({ field: 'cutMinutes', message: 'Captura al menos un tiempo de corte o grabado mayor a cero.' });
    if (!['batch', 'unit'].includes(job.timeBasis)) errors.push({ field: 'timeBasis', message: 'Selecciona a qué corresponde el tiempo.' });
    const minutes = (cut + engrave) * (job.timeBasis === 'unit' ? quantity : 1);
    const rate = read('rate', 'Costo de máquina por minuto', { required: true, min: 0.01 });
    const design = read('design', 'Diseño y preparación');
    const finishing = read('finishing', 'Acabados del lote');
    const percent = read('profit', 'Porcentaje de utilidad', { max: job.profitMode === 'margin' ? 99.99 : 10000 });
    if (!['markup', 'margin'].includes(job.profitMode)) errors.push({ field: 'profitMode', message: 'Selecciona un método de utilidad.' });
    const minimum = read('minimum', 'Venta mínima');
    const discountPercent = read('discount', 'Descuento', { max: 100 });
    const taxPercent = read('tax', 'Impuesto', { max: 100 });
    if (errors.length) return { valid: false, errors, quantity, width, height, area, minutes, perSheet, sheets };
    materialCost = money(materialCost);
    const machineCost = money(minutes * rate);
    const cost = money(materialCost + machineCost + design + finishing);
    const suggested = money(job.profitMode === 'margin' ? cost / (1 - percent / 100) : cost * (1 + percent / 100));
    const base = money(Math.max(suggested, minimum));
    if (![materialCost, machineCost, cost, suggested, base].every(n => Number.isFinite(n) && n <= 1e12)) {
      return { valid: false, errors: [{ field: 'rate', message: 'El importe excede el límite del cotizador. Revisa tiempo, tarifa y cantidad.' }], quantity, width, height, area, minutes, perSheet, sheets };
    }
    const minimumAdjustment = money(base - suggested);
    const discount = money(base * discountPercent / 100);
    const subtotal = money(base - discount);
    const tax = money(subtotal * taxPercent / 100);
    const total = money(subtotal + tax);
    const profit = money(subtotal - cost);
    return { valid: true, errors: [], quantity, width, height, area, chargeArea, perSheet, sheets, minutes, materialCost, machineCost, design: money(design), finishing: money(finishing), cost, suggested, base, minimumAdjustment, discount, discountPercent, subtotal, tax, taxPercent, total, unit: money(total / quantity), profit, profitPercent: subtotal > 0 ? profit / subtotal * 100 : 0 };
  }
  root.CpLaserMath = { calculate, money };
  if (typeof module !== 'undefined' && module.exports) module.exports = root.CpLaserMath;
})(typeof globalThis !== 'undefined' ? globalThis : this);
