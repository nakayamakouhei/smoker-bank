// クリック委任でどのページでも動く
document.addEventListener("click", (e) => {
  const btn = e.target.closest(".password-toggle-btn");
  if (!btn) return;

  const fieldId = btn.dataset.target;
  const field = document.getElementById(fieldId);
  if (!field) return;

  const eyeOn  = btn.querySelector(".eye-on");
  const eyeOff = btn.querySelector(".eye-off");

  const reveal = field.type === "password";
  field.type = reveal ? "text" : "password";

  // 表示を入れ替え（Tailwind の hidden を利用）
  if (eyeOn && eyeOff) {
    eyeOn.classList.toggle("hidden", reveal);   // テキスト表示時は斜線アイコンだけ見せる
    eyeOff.classList.toggle("hidden", !reveal);
  }
});
