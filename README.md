# Universal GKI Kernel Builder CI
### (Pure GKI 2.0 only)

Welcome to the Universal GKI Kernel Builder! This repository hosts an automated, highly flexible GitHub Actions CI pipeline designed to compile custom GKI kernels directly from source. 

Whether you need a pristine upstream kernel or a heavily modified build featuring custom VFS patches, Kconfig overrides, and systemless integrations, this pipeline builds exactly what you want, right when you want it.

## 🚀 Overview

The core philosophy of this project is **Precision Generation over Bulk Compilation**. 

Unlike massive kernel distribution repositories that compile hundreds of generic permutations on a fixed schedule, this CI is designed to be a personal build engine. When you trigger a workflow, the pipeline precisely resolves the correct Google manifest branches, fetches your chosen root environment, and integrates custom patches and config overrides on the fly. 

To balance this immense flexibility with device safety, the project is strictly divided into two build channels:
*   **The Stable Channel (Default & Recommended):** Builds from locked-down, verified source forks. This completely insulates your device from upstream chaos, guaranteeing a safe compile and a reliable boot for your daily driver.
*   **The Dynamic Channel (Volatile & High Risk):** Pulls the absolute latest upstream commits for testing and development. **⚠️ Warning:** This channel is highly prone to severe build failures and device bootloops caused by experimental upstream architectural changes. Proceed with caution.

### ✨ Advantages
* **Rock-Solid Stability:** By defaulting to the `stable` channel, you get all the benefits of a custom CI pipeline without the risk of flashing broken upstream code.
* **No Waiting for Updates:** If Google drops a new GKI update, you can build it yourself immediately without waiting for a maintainer.
* **Bleeding Edge Testing:** When you want to hunt bugs or test new features, the `dynamic` channel lets you intentionally pull raw upstream commits to see what breaks.
* **Precision Output:** Instead of sifting through hundreds of zip files, the CI builds exactly what you ask for and packages it cleanly.
* **Guaranteed Version Matching:** The pipeline automatically fetches the exact Manager APK that matches the root environment source code used during compilation. No more signature mismatches or incompatible userspace apps.

## ⚙️ Features
* **Multiple Root Managers:** Native integration support for `KernelSU`, `KernelSU-Next`, `SukiSU-Ultra`, `BakaSU`, and `ReSukiSU` (retained as a legacy fallback branch in case of BakaSU instability).
* **Smart Stock Isolation:** Select `Stock` to guarantee a pristine Google source tree. Combine `Stock` with custom Kconfigs to build an "Enhanced Stock" kernel—perfect for APatch or Magisk users who need specific kernel features baked into the core without conflicting root source code pollution.
* **SuSFS Integration:** Automated patching and macro injection for SuSFS to enable advanced path hiding, kstat spoofing, and mount masking.
* **NoMount VFS:** Native integration of maxsteeel's NoMount for advanced kernel-level path redirection. The pipeline dynamically hooks the independent VFS tree directory and outputs a ready-to-flash KernelSU metamodule alongside the kernel.
* **Performance Networking:** Built-in fragment support for TCP BBR congestion control and FQ_CODEL scheduling to minimize bufferbloat and optimize latency.
* **Modular Customization Engine:** Intelligently inject custom Kconfig fragments, version-aware `.patch` files, and raw kernel source modifications on demand across versions 5.10 to 6.12.
* **Flexible Packaging:** Outputs a standard `AnyKernel3` (AK3) flashable zip by default. If you provide a full OTA URL, it will extract, patch, and repack a raw `boot.img` for direct fastboot flashing.

---

## 🛠️ How to Use

To start building your own custom kernels, follow these steps:

### 1. Fork the Repository
Click the **Fork** button at the top right of this page to create your own copy of the repository.

### 2. Add Your Custom Files (Optional)
If you plan to use the Customization Engine, place your files in the respective directories before running the workflow:
* **Custom Kconfigs:** Place or un-hash preconfigured flags in `tools/custom.fragment` (e.g., `CONFIG_TCP_CONG_BBR=y`).
* **User Patches:** Drop any `.patch` files into `tools/user_patches/`. The CI will intelligently apply them based on the kernel version prefix (e.g., `6.1-fix.patch` will only apply to 6.1 builds). *(Note: Blocked when `Stock` is selected)*
* **User Source:** Drop raw driver files or source overrides into `tools/user_source/` (e.g., placing NoMount source in `tools/user_source/fs/nomount/`). *(Note: Blocked when `Stock` is selected)*

### 3. Enable GitHub Actions
In your forked repository, navigate to the **Actions** tab. Click **"I understand my workflows, go ahead and enable them"**.

### 4. Trigger a Build
1. On the **Actions** tab, select **Build Custom GKI** from the left sidebar.
2. Click the **Run workflow** dropdown on the right side of the screen.
3. Fill out the configuration parameters for your build:

| Parameter | Description |
| :--- | :--- |
| **Build Channel** | Choose `stable` (**Recommended default**, tested and verified to boot safely) or `dynamic` (Bleeding-edge upstream commits. **Warning:** Highly volatile, prone to compile errors and bootloops). |
| **Build Name** | A custom name for your output artifact (e.g., `Pixel_10_Pro_Testing`). |
| **Kernel Version** | The exact GKI target version you wish to build (e.g., `6.12.11`). |
| **Root Environment** | Select your preferred root manager from the dropdown list (`KernelSU`, `KernelSU-Next`, `SukiSU-Ultra`, `BakaSU`, `ReSukiSU`, or `Stock`). |
| **Integrate Root Manager and SUSFS?** | Check to inject Kernel root and SUSFS. *(Ignored if `Stock` is selected).* |
| **Inject NoMount VFS?** | Check to dynamically wire NoMount source directories into the VFS Kbuild tree and download the NoMount metamodule. |
| **Enable Performance Networking?** | Check to apply custom network Kconfigs and version-aware `.patch` files to the kernel source tree. |
| **OTA URL (Optional)** | Leave blank to output an `AnyKernel3` zip. Provide a direct link to a full OTA zip to output a pre-patched `boot.img`. |

4. Click **Run workflow**.

### 5. Download Your Artifacts
Once the CI pipeline completes successfully, scroll to the bottom of the workflow summary page. Under the **Artifacts** section, you will find your compiled kernel (either an AK3 zip or a zip containing a repacked boot image plus an AK3 zip), your NoMount metamodule (if enabled), and the exact Manager APK required to control it. Download, flash via Kernel Flasher or custom recovery, and enjoy!
