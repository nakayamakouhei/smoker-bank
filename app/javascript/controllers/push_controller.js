// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//     static values = { publicKey: String }

//     async subscribe() {
//         const registration = await navigator.serviceWorker.ready;

//         const subscription = await registration.pushManager.subscribe({
//             userVisibleOnly: true,
//             applicationServerKey: this.urlBase64ToUint8Array(this.publicKeyValue),
//         });

//         await fetch("/push_subscriptions", {
//             method: "POST",
//             headers: {
//                 "Content-Type": "application/json",
//                 "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
//             },
//             body: JSON.stringify(subscription),
//         });

//         alert("通知を登録しました");
//     }

//     // helper
//     urlBase64ToUint8Array(base64String) {
//         const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
//         const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
//         const rawData = atob(base64);
//         return Uint8Array.from([...rawData].map((c) => c.charCodeAt(0)));
//     }
// }
