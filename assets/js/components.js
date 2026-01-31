
// assets/js/components.js

export function renderSidebar(activePage = 'dashboard', role = 'student') {
    const isTeacher = role === 'teacher';

    const linkClasses = (isActive) => isActive
        ? 'bg-brand-teal text-white font-semibold shadow-lg shadow-brand-teal/20'
        : 'text-gray-500 hover:bg-brand-teal/10 hover:shadow-sm hover:text-brand-teal';

    const iconClasses = (isActive) => isActive
        ? 'text-white'
        : 'text-brand-teal/70 group-hover:text-brand-teal';

    // Collapsible Logic Script
    const sidebarScript = `
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('main-sidebar');
                const texts = sidebar.querySelectorAll('.nav-text');
                const logoText = document.getElementById('logo-text');
                const toggleIcon = document.getElementById('toggle-icon');
                const mainContent = document.querySelector('main');
                const collapseContainer = document.getElementById('collapse-container');
                
                if (sidebar.classList.contains('w-64')) {
                    // Collapse
                    sidebar.classList.replace('w-64', 'w-20');
                    texts.forEach(t => t.classList.add('hidden'));
                    logoText.classList.add('hidden');
                    toggleIcon.classList.replace('fa-chevron-left', 'fa-chevron-right');
                    
                    // Center the button container when collapsed
                    collapseContainer.classList.replace('justify-end', 'justify-center');
                    
                    mainContent.classList.replace('md:ml-64', 'md:ml-20');
                } else {
                    // Expand
                    sidebar.classList.replace('w-20', 'w-64');
                    texts.forEach(t => t.classList.remove('hidden'));
                    logoText.classList.remove('hidden');
                    toggleIcon.classList.replace('fa-chevron-right', 'fa-chevron-left');
                    
                    // Align button to end when expanded
                    collapseContainer.classList.replace('justify-center', 'justify-end');
                    
                    mainContent.classList.replace('md:ml-20', 'md:ml-64');
                }
            }
        </script>
    `;

    let menuContent = '';

    if (isTeacher) {
        // Simplified Top-Level Menu for Teachers
        menuContent = `
         <a href="teacher-dashboard.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'dashboard')}" title="Dasbor">
            <div class="w-6 flex justify-center"><i class="fas fa-chalkboard-teacher transition-colors ${iconClasses(activePage === 'dashboard')}"></i></div>
            <span class="font-medium nav-text whitespace-nowrap">Dasbor</span>
        </a>
        
        <div class="mt-4 mb-2 text-xs font-bold text-gray-400 px-4 uppercase tracking-wider nav-text">Pengajaran</div>
        
        <a href="manage-lessons.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'manage-lessons')}" title="Kelola Pelajaran">
            <div class="w-6 flex justify-center"><i class="fas fa-book-open transition-colors ${iconClasses(activePage === 'manage-lessons')}"></i></div>
            <span class="font-medium nav-text whitespace-nowrap">Kelola Pelajaran</span>
        </a>

        <a href="students.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'students')}" title="Siswa">
             <div class="w-6 flex justify-center"><i class="fas fa-users transition-colors ${iconClasses(activePage === 'students')}"></i></div>
            <span class="font-medium nav-text whitespace-nowrap">Siswa</span>
        </a>

        <a href="teacher-assignments.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'assignments')}" title="Tugas">
             <div class="w-6 flex justify-center"><i class="fas fa-tasks transition-colors ${iconClasses(activePage === 'assignments')}"></i></div>
            <span class="font-medium nav-text whitespace-nowrap">Tugas</span>
        </a>
        `;
    } else {
        // Student Menu
        menuContent = `
        <a href="student-dashboard.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'dashboard')}">
             <div class="w-6 flex justify-center"><i class="fas fa-home transition-colors ${iconClasses(activePage === 'dashboard')}"></i></div>
            <span class="font-medium nav-text whitespace-nowrap">Dasbor</span>
        </a>

         <div class="mt-4 mb-2 text-xs font-bold text-gray-400 px-4 uppercase tracking-wider nav-text">Pembelajaran</div>

         <a href="courses.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'courses')}">
             <div class="w-6 flex justify-center"><i class="fas fa-book transition-colors ${iconClasses(activePage === 'courses')}"></i></div>
            <span class="font-medium nav-text whitespace-nowrap">Semua Kursus</span>
        </a>
         <a href="assignments.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'assignments')}">
             <div class="w-6 flex justify-center"><i class="fas fa-tasks transition-colors ${iconClasses(activePage === 'assignments')}"></i></div>
            <span class="font-medium nav-text whitespace-nowrap">Tugas</span>
        </a>
        `;
    }

    return `
    <aside id="main-sidebar" class="fixed left-0 top-0 h-full w-64 bg-brand-cream border-r border-orange-100 z-40 hidden md:flex flex-col shadow-xl shadow-brand-orange/5 transition-all duration-300">
        <div class="p-6 flex items-center gap-3 overflow-hidden">
            <img src="assets/images/logo.png" alt="BelajarMas" class="w-10 h-10 object-contain">
            <span id="logo-text" class="text-xl font-heading font-bold text-brand-black tracking-wide whitespace-nowrap">BelajarMas</span>
        </div>

        <!-- Collapse Button (Icon Only) -->
        <div id="collapse-container" class="px-6 mb-2 flex justify-end">
            <button id="collapse-btn" onclick="toggleSidebar()" class="w-8 h-8 rounded-lg flex items-center justify-center text-gray-400 hover:bg-brand-teal/10 hover:shadow-sm hover:text-brand-teal transition-all" title="Alihkan Sidebar">
                <i id="toggle-icon" class="fas fa-chevron-left"></i>
            </button>
        </div>

        <nav class="flex-1 px-4 space-y-1 mt-4 overflow-y-auto overflow-x-hidden">
            ${menuContent}
            
            <div class="mt-8 border-t border-gray-200/50 pt-4">
                <div class="text-xs font-bold text-gray-400 px-4 uppercase tracking-wider mb-2 nav-text">Akun</div>
                <a href="profile.html" class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all group ${linkClasses(activePage === 'profile')}">
                     <div class="w-6 flex justify-center"><i class="fas fa-user transition-colors ${iconClasses(activePage === 'profile')}"></i></div>
                    <span class="font-medium nav-text whitespace-nowrap">Profil</span>
                </a>
            </div>
        </nav>

        <div class="p-4 border-t border-gray-200/50 space-y-2">
            <!-- Collapse Button -->
            <!-- Collapse Button Moved to Top -->

            <button id="logoutBtn" class="flex items-center gap-4 px-4 py-3 w-full rounded-xl text-gray-500 hover:bg-red-50 hover:text-red-500 transition-all group" title="Keluar">
                 <div class="w-6 flex justify-center"><i class="fas fa-sign-out-alt group-hover:text-red-500"></i></div>
                <span class="font-medium nav-text whitespace-nowrap">Keluar</span>
            </button>
        </div>
    </aside>
    `;
}

// Make toggleSidebar global so onclick attributes work
window.toggleSidebar = function () {
    const sidebar = document.getElementById('main-sidebar');
    const texts = sidebar.querySelectorAll('.nav-text');
    const logoText = document.getElementById('logo-text');
    const toggleIcon = document.getElementById('toggle-icon');
    const mainContent = document.querySelector('main');
    const collapseContainer = document.getElementById('collapse-container');

    if (sidebar.classList.contains('w-64')) {
        // Collapse
        sidebar.classList.replace('w-64', 'w-20');
        texts.forEach(t => t.classList.add('hidden'));
        logoText.classList.add('hidden');
        toggleIcon.classList.replace('fa-chevron-left', 'fa-chevron-right');

        // Center the button when collapsed
        collapseContainer.classList.replace('justify-end', 'justify-center');

        mainContent.classList.replace('md:ml-64', 'md:ml-20');

        // Dispatch resize event for charts/grids
        window.dispatchEvent(new Event('resize'));
    } else {
        // Expand
        sidebar.classList.replace('w-20', 'w-64');
        texts.forEach(t => t.classList.remove('hidden'));
        logoText.classList.remove('hidden');
        toggleIcon.classList.replace('fa-chevron-right', 'fa-chevron-left');

        // Restore right alignment when expanded
        collapseContainer.classList.replace('justify-center', 'justify-end');

        mainContent.classList.replace('md:ml-20', 'md:ml-64');

        window.dispatchEvent(new Event('resize'));
    }
};

export function renderMobileHeader() {
    return `
    <header class="md:hidden bg-brand-cream sticky top-0 z-50 px-6 py-4 flex items-center justify-between border-b border-orange-100">
        <div class="flex items-center gap-3">
            <img src="assets/images/logo.png" alt="BelajarMas" class="w-8 h-8 object-contain">
            <span class="text-lg font-heading font-bold text-brand-black">BelajarMas</span>
        </div>
        <button class="text-gray-600 hover:text-brand-teal">
            <i class="fas fa-bars text-xl"></i>
        </button>
    </header>
    `;
}
